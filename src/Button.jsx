import PropTypes from 'prop-types';

export const Button = ({ children, onClick, disabled = false }) => {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`max-w-xl w-4/5 mx-auto flex items-center justify-center gap-2 border-black border-[3px] transition-all rounded-sm py-4 px-8 my-4 font-semibold text-white bg-lavender-blue-500 shadow-[5px_5px_0px_rgba(0,0,0,1)] overflow-hidden ${disabled ? 'opacity-25' : 'hover:bg-lavender-blue-600 active:bg-lavender-blue-400 active:shadow-none active:translate-x-[5px] active:translate-y-[5px]'}`}
    >
      <span className="text-xs md:text-xl truncate">{children}</span>{' '}
      {/* 텍스트를 자동으로 축소하거나 잘라냅니다. */}
    </button>
  );
};

Button.propTypes = {
  children: PropTypes.node.isRequired,
  onClick: PropTypes.func.isRequired,
  disabled: PropTypes.bool,
};
