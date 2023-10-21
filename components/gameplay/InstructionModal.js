import LetterBox from "./LetterBox";

export default function InstructionModal({ clickHandler }) {
  return (
    <div className="w-[60%] mx-auto h-[80vh] rounded-lg bg-black py-3">
      <div className="flex justify-between">
        <h1 className="text-3xl text-center text-white w-full">What you should know</h1>
        <img src="./images/material-symbols_close-fullscreen.png" alt="" className="block mr-3" onClick={clickHandler} />
      </div>

      <p className="mt-3 w-[40%] text-center text-white mx-auto">
        Try guessing the correct word in six (6) tries. After each try, the tile changes color to show you how close you were to the correct word. You get 20 points for each correct word and spot.
      </p>

      <div className="mt-3">
        <h2 className="text-2xl text-center text-white"> See this!</h2>
        {renderLetterRow("word", ["w", "o", "r", "d", "s"], [false, false, true, false, false], "R is correct and in the correct spot")}
        {renderLetterRow("rainy", ["r", "a", "i", "n", "y"], [true, false, false, false, true], "Y is correct and in the wrong spot")}
        {renderLetterRow("skips", ["s", "k", "i", "p", "s"], [false, false, false, false, false], "No letter is in the correct or in the right spot")}
      </div>
    </div>
  );
}

function renderLetterRow(word, letters, letterStatus, description) {
  return (
    <div className="mt-3 flex w-[40%] mx-auto justify-between">
      {letters.map((letter, index) => (
        <LetterBox key={index} letter={letter} correct={letterStatus[index]} wrong={!letterStatus[index]} />
      ))}
      <p className="mt-2 text-2xl text-center text-white">{description}</p>
    </div>
  );
}
