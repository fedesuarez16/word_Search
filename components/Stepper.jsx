import React, { useState, useEffect, useRef } from "react";

const Stepper = ({ steps, currentStep }) => {
  const [updatedSteps, setUpdatedSteps] = useState([]);
  const stepsStateRef = useRef();

  const updateStep = (stepNumber, steps) => {
    return steps.map((step, index) => {
      if (index === stepNumber) {
        return {
          ...step,
          highlighted: true,
          selected: true,
          completed: true,
        };
      } else if (index < stepNumber) {
        return {
          ...step,
          highlighted: false,
          selected: true,
          completed: true,
        };
      } else {
        return {
          ...step,
          highlighted: false,
          selected: false,
          completed: false,
        };
      }
    });
  };

  useEffect(() => {
    const initialSteps = steps.map((step, index) => ({
      description: step,
      completed: false,
      highlighted: index === 0 ? true : false,
      selected: index === 0 ? true : false,
    }));

    stepsStateRef.current = initialSteps;
    const current = updateStep(currentStep - 1, stepsStateRef.current);
    setUpdatedSteps(current);
  }, [steps, currentStep]);

  const stepsDisplay = updatedSteps.map((step, index) => (
    <div
      key={index}
      className={index !== updatedSteps.length - 1 ? "w-full flex items-center" : "flex items-center"}
    >
      <div className="relative flex flex-col items-center text-teal-600">
        <div
          className={`rounded-xl transition bg-[#F9F9F9] text-black duration-500 ease-in-out h-12 w-12 flex items-center justify-center py-3 ${
            step.selected ? "bg-[#FFB900] font-bold shadow-xl" : ""
          }`}
        >
          <span className="font-bold text-xl">{index + 1}</span>
        </div>
      </div>
      <div className={`flex-auto border-t-2 transition duration-500 ease-in-out border-black`}></div>
    </div>
  ));

  return (
    <div className="mx-4 flex justify-between items-center">
      {stepsDisplay}
    </div>
  );
};

export default Stepper;
