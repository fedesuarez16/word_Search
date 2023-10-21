export default function LetterBox({ letter, status }) {
  const statusClass = {
    right: "bg-green-400",
    wrong: "bg-yellow-600",
  default: "bg-slate-100",
  // Add more statuses and corresponding classes as needed
  };

  const getClassForStatus = (status) => statusClass[status] || statusClass.default;

  return (
    <div className={`w-20 h-20 flex justify-center items-center text-4xl p-5 rounded-xl uppercase font-bold text-white ${getClassForStatus(status)}`}>
      {letter}
    </div>
  );
}
