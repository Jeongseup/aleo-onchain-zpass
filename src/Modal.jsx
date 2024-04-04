import React from 'react';
import PropTypes from 'prop-types';

export const Modal = ({ isOpen, onClose, title, content }) => {
  if (!isOpen) return null;

  const formattedContent = JSON.stringify(content, null, 1); // JSON을 예쁘게 포매팅합니다.

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50">
      <div className="bg-white p-8 rounded-lg shadow-lg w-full max-w-md mx-auto">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-2xl font-bold text-black">{title}</h2>
          <button onClick={onClose} className="text-black">
            &#x2715;
          </button>
        </div>
        <pre className="whitespace-pre-wrap text-black bg-gray-100 rounded p-4 max-h-80 overflow-auto">
          <code>{formattedContent}</code>
        </pre>
        <button
          onClick={onClose}
          className="mt-4 px-4 py-2 border-black border-[3px] transition-all rounded-sm font-semibold text-white bg-lavender-blue-500 hover:bg-lavender-blue-600 active:bg-lavender-blue-400 shadow-[5px_5px_0px_rgba(0,0,0,1)] w-full text-center"
        >
          Close
        </button>
      </div>
    </div>
  );
};

// export const Modal = ({ isOpen, onClose, content }) => {
//   if (!isOpen) return null;

//   return (
//     <div className="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center">
//       <div className="bg-white p-4 rounded-lg shadow-lg max-w-sm mx-auto">
//         <div className="flex justify-between items-center">
//           <h2 className="text-xl font-bold">Alert</h2>
//           <button onClick={onClose} className="text-black">
//             &#x2715; {/* 이것은 X 문자를 나타내는 유니코드입니다 */}
//           </button>
//         </div>
//         <p className="my-2">{content}</p>
//         <button
//           onClick={onClose}
//           className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
//         >
//           Close
//         </button>
//       </div>
//     </div>
//   );
// };

Modal.propTypes = {
  isOpen: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  content: PropTypes.node,
};
