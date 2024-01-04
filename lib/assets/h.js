import { ObjectType } from "@/model/app";
import { useLexicalComposerContext } from "@lexical/react/LexicalComposerContext";
import React, { useCallback, useEffect, useRef, useState } from 'react';

type WordAttribute = {
    left: string;
    top: string;
    width: string;
    height: string;
}

const highlights = ['leading provider of artificial intelligence', "yet powerful idea: understanding", "people will interact", "customers with the"]

const ErrorGeneratorPlugin = () => {
    const [editor] = useLexicalComposerContext();
    const [highlightingWords, setWords] = useState<ObjectType<Array<WordAttribute>>>({});
    const containerRef = useRef<HTMLDivElement>(null);

    function createOverlay(startNode: Element, startIndex: number, endIndex: number, textToFind: string): Array<WordAttribute> | null {

        if (!containerRef.current) return null;

        // Calculate the position and width of the overlay
        const range = document.createRange();
        range.setStart(startNode, startIndex);
        range.setEnd(startNode, endIndex);
        const rects = Array.from(range.getClientRects());

        const containerRect = containerRef.current.getBoundingClientRect();

        return rects.map(rect => {
            return {
                left: (rect.left - containerRect.left) + 'px',
                top: (rect.top - containerRect.top) + 'px', // 2px border, adjust as needed
                width: (rect.width || 1) + 'px', // Ensure a minimum width
                height: (rect.height || 1) + 'px' // Ensure a minimum height
            }
        })
    }

    const getTextPosition = useCallback((root: Element, textToFind: string): Array<WordAttribute> | null => {
        const elements = root.querySelectorAll('[data-lexical-text="true"]');
        let startIndex = -1;
        let elIndex = 0;

        for (let i = 0; i < elements.length; i++) {
            const elementText = elements[i].textContent;

            if (!elementText) continue;

            const index = elementText.indexOf(textToFind);
            if (index !== -1) {
                startIndex = index;
                elIndex = i;
                break;
            }
        }


        if (startIndex !== -1) {
            const endIndex = startIndex + textToFind.length;
            const child = elements[elIndex].firstChild ? elements[elIndex].firstChild : elements[elIndex];

            return createOverlay(child as Element, startIndex, endIndex, textToFind);
        }

        return null;
    }, []);

    useEffect(() => {
        return editor.registerUpdateListener((editorState) => {
            const root = editor.getRootElement();
            if (root) {
                if (containerRef.current) {
                    containerRef.current.style.height = root.scrollHeight + 'px';
                    containerRef.current.style.width = root.scrollWidth + 'px';
                }

                const dimensions = highlights.reduce((result, text) => {
                    const dim = getTextPosition(root, text);
                    if (dim) result[text] = dim
                    return result;
                }, {} as ObjectType<Array<WordAttribute>>);

                if (Object.keys(dimensions).length) setWords(dimensions)
            }
        });
    }, [editor, getTextPosition]);

    return (
        <div ref={containerRef} className="absolute top-0 left-0 pointer-events-none z-auto">
            {
                Object.keys(highlightingWords).map((word, index) => {
                    const rects = highlightingWords[word];
                    return (
                        <div key={index}>
                            {rects.map((rect) => {
                                const { left, top, width, height } = rect;
                                return <span key={`${left}-${top}-${width}-${height}`} style={{ top, left, width, height }} className="bg-primary absolute" />
                            })}
                        </div>
                    )

                })
            }
        </div>
    );
}

export default ErrorGeneratorPlugin;