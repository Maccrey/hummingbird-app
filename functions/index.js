/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const { onSchedule } = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

async function getUserSetting(userId) {
  try {
    const userSettingDoc = await db.collection("userSetting").doc(userId).get();
    if (userSettingDoc.exists) {
      const data = userSettingDoc.data();
      if (data && data[userId]) {
        return data[userId];
      }
    }
    return null;
  } catch (error) {
    console.error("Error fetching user setting:", error);
    return null;
  }
}

exports.dailyLeaderboardUpdate = onSchedule(
  {
    schedule: "0 6 * * *",
    timeZone: "Asia/Seoul",
  },
  async () => {
    const now = new Date();
    now.setUTCHours(now.getUTCHours() + 9);
    now.setDate(now.getDate() - 1);
    const dateKey = now.toISOString().split("T")[0];
    const yearMonth = dateKey.substring(0, 7);

    const usersSnapshot = await db.collection("studyRecords").listDocuments();
    let leaderboardData = [];

    for (const userDoc of usersSnapshot) {
      const userId = userDoc.id;
      const studyRecordsRef = db
        .collection("studyRecords")
        .doc(userId)
        .collection(yearMonth);

      const querySnapshot = await studyRecordsRef
        .where("dateKey", "==", dateKey)
        .get();

      let totalElapsedTime = 0;
      querySnapshot.forEach((doc) => {
        totalElapsedTime += doc.data().elapsedTime || 0;
      });

      if (userId && totalElapsedTime > 0) {
        let nickname = "Unknown";
        let country = null;

        // 사용자 정보 가져오기
        const userSetting = await getUserSetting(userId);
        if (userSetting) {
          nickname = userSetting.nickname || "Unknown";
          country = userSetting.country || null;
        }

        leaderboardData.push({ userId, totalElapsedTime, nickname, country });
      }
    }

    leaderboardData.sort((a, b) => b.totalElapsedTime - a.totalElapsedTime);

    if (leaderboardData.length > 0) {
      const sortedLeaderboard = {};
      leaderboardData.forEach((entry, index) => {
        sortedLeaderboard[`rank_${index + 1}`] = {
          rank: index + 1,
          userId: entry.userId,
          nickname: entry.nickname,
          totalElapsedTime: entry.totalElapsedTime,
          country: entry.country,
        };
      });

      await db.collection("Leaderboard").doc(dateKey).set(sortedLeaderboard);
    }
  }
);
