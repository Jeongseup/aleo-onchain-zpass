import React from 'react';

export const Card = ({ title, content, disabled }) => {
  if (disabled) return null;
  // Content가 배열인지 확인하고, 맞다면 내부 카드를 렌더링하는 함수
  const renderContent = (content) => {
    // 배열이면 내부 카드로 처리
    if (Array.isArray(content)) {
      return content.map((item, index) => (
        <div key={index}>
          <pre className="whitespace-pre-wrap text-black bg-gray-100 m-4 border-2 border-gray-300 rounded p-4 max-h-40 overflow-auto">
            <code>{item}</code>
          </pre>
        </div>
      ));
    }
    // 배열이 아니라 문자열이면 그대로 텍스트로 처리
    return <p className="text-gray-700 text-base">{content}</p>;
  };
  return (
    <div className="flex justify-center items-center h-auto">
      <div className="max-w-md md:max-w-lg rounded overflow-hidden shadow-lg m-4">
        <div className="px-6 py-4">
          <div className="font-bold text-xl mb-2">{title}</div>
          {/* Content 렌더링 처리 변경 */}
          {renderContent(content)}
        </div>
      </div>
    </div>
  );
};
