import React, { useEffect, useState } from "react";
import GameScoreCard from "./GameScoreCard";
import InstructionModal from "./InstructionModal";
import Keyboard from "./Keyboard";
import WordBox from "./WordBox";
import { useGameContext } from "../../contexts";
import { useRouter } from "next/router";
import Swal from "sweetalert2";

export default function GameBoard() {
  const [wordArray, setWordArray] = useState([]);
  const [showModal, setShowModal] = useState(false);

  const {
    updateWordState,
    isStarted,
    initGame,
    startTimer,
    fetchUserWord,
    playedGame,
    gameEnded,
  } = useGameContext();

  const router = useRouter();

  const displayModal = () => {
    setShowModal(!showModal);
  };

  const getKeyboardInput = async (letter) => {
    if (letter === "Enter") {
      if (wordArray.length === 5) {
        const { modWordArray, isAllCorrect } = await updateWordState(wordArray);
        if (isAllCorrect) {
          setWordArray(modWordArray);
          Swal.fire("You won! Click submit to confirm.");
        } else {
          setWordArray(modWordArray);
        }
      }
    } else if (letter === "Del" && wordArray.length > 0) {
      setWordArray((prevArray) => prevArray.slice(0, -1));
    } else if (wordArray.length <= 5) {
      if (!isStarted) {
        Swal.fire("Game starts now");
        await initGame();
        Swal.fire("Fetching word...");
        await fetchUserWord();
        Swal.fire("Word fetched.");
        await startTimer();
      }
      setWordArray((prevArray) => [...prevArray, { letter }]);
    }
  };

  const submitGame = async () => {
    if (wordArray.length === 5) {
      await playedGame(wordArray);
      alert("Congratulations! You've been awarded tokens. Check your balance.");
      router.push("/staking");
    } else {
      alert("You can't submit until you fill all the words. Test correctness with Enter key first.");
    }
  };

  useEffect(() => {
    if (isStarted && gameEnded) {
      alert("The game has ended.");
      router.push("/home");
    }
  });

  return (
    <div className="h-full bg-gray-400 rounded-md bg-clip-padding backdrop-filter mt-10 backdrop-blur-lg bg-opacity-20 border border-gray-100 w-[90%] mx-auto mt-8 py-12 relative">
      {showModal && <InstructionModal clickHandler={displayModal} />}
      {!showModal && (
        <>
          <a href="" className="inline-block absolute top-0 left-[97%]">
            <img src="./images/mdi_close-circle.png" alt="cancel" className="mt-3" />
          </a>
          <GameScoreCard clickHandler={displayModal} />
          <div className="mt-5 flex w-[80%] mx-auto gap-12">
            <div className="w-full">
              <WordBox wordArray={wordArray} />
            </div>
          </div>
          <div className="mt-5">
            <Keyboard clickHandler={getKeyboardInput} />
          </div>
          <div className="mt-5">
            <button className="btn block mx-auto" onClick={submitGame}>
              Submit
            </button>
          </div>
        </>
      )}
    </div>
  );
}
