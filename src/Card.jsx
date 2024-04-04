import React from 'react';

export const Card = ({ title, content, disabled }) => {
  if (disabled) return null;

  return (
    <div className="flex justify-center items-center h-auto">
      <div className="max-w-md md:max-w-lg rounded overflow-hidden shadow-lg m-4">
        <div className="px-6 py-4">
          <div className="font-bold text-xl mb-2">{title}</div>
          <p className="text-gray-700 text-base">{content}</p>
        </div>
      </div>
    </div>
  );
};
