import cn from 'classnames';
import React, { useEffect, useState } from 'react';
import { isValidUrl } from '@/logic/utils';
import { FieldPath, FieldValues, useFormContext } from 'react-hook-form';
import { ColorPickerField } from './ColorPicker';
import XIcon from './icons/XIcon';
import LinkIcon from './icons/LinkIcon';

export type ImageOrColorFieldState = 'image' | 'color';

export interface ImageOrColorFieldProps<FormType extends FieldValues> {
  fieldName: FieldPath<FormType>;
  state?: ImageOrColorFieldState;
  setState?: (state: ImageOrColorFieldState) => void;
  defaultColor?: string;
}

export default function ImageOrColorField<FormType extends FieldValues>({
  fieldName,
  state,
  setState,
  defaultColor = '#D9D9D9',
}: ImageOrColorFieldProps<FormType>) {
  const {
    register,
    setValue,
    formState: { errors },
  } = useFormContext<FormType>();
  const [type, setType] = useState<ImageOrColorFieldState>('color');
  const status = state || type;
  const setStatus = setState || setType;

  useEffect(() => {
    setStatus('color');
    setValue(fieldName, defaultColor as any);
  }, [defaultColor, fieldName, setStatus, setValue]);

  const handleColorIconType = (e: React.SyntheticEvent) => {
    e.preventDefault();
    setStatus('color');
    setValue(fieldName, defaultColor as any);
  };

  const handleImageIconType = (e: React.SyntheticEvent) => {
    e.preventDefault();
    setStatus('image');
    setValue(fieldName, '' as any, {
      shouldDirty: true,
      shouldTouch: true,
    });
  };

  return (
    <>
      <div className="flex w-full items-center space-x-2">
        {status === 'image' ? (
          <div className="input flex w-full items-center">
            <div className="flex items-center justify-center">
              <LinkIcon className="h-4 w-4 text-gray-600" />
            </div>
            <input
              className={cn('input-inner grow rounded-none py-0', {})}
              placeholder="Paste Image URL Here"
              {...register(fieldName, {
                required: true,
                validate: (value) => isValidUrl(value),
              })}
            />
            <button
              className="flex items-center justify-center"
              onClick={handleColorIconType}
            >
              <XIcon className="h-4 w-4" />
            </button>
          </div>
        ) : null}
        {status === 'color' ? (
          <div className="input flex w-full items-center rounded-lg px-1 py-0.5">
            <ColorPickerField fieldName={fieldName} className="grow" />
            <button
              className="small-button line-break-none w-max"
              onClick={handleImageIconType}
            >
              Add Image
            </button>
          </div>
        ) : null}
      </div>
      {errors[fieldName] ? (
        <span className="text-sm">{errors[fieldName]?.message}</span>
      ) : null}
    </>
  );
}
