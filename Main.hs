module Main where

import Control.Monad
import Data.IORef
import Graphics.UI.GLUT 
import System.Random (randomRIO)
import Unsafe.Coerce (unsafeCoerce)
import Window


main :: IO ()
main = do
    list <- newIORef []
    book <- loadImage "book.png"
    font <- openFont "ubuntu.ttf"
    let wc = WindowConfig {
        -- FRAME
        frameHandler = FrameHandler $ do
            color $ Color3 1 1 (1 :: GLdouble)
            drawImage book
            {-
            pNew <- randomPoint (0, 1.3)
            modifyIORef list (pNew:) 
            l <- readIORef list
            when (length l `mod` 100 == 0) $
                putStrLn $ "Number of lines: " ++ show (length l)
            forM_ l $ \(x,y) -> do 
                color $ Color3 (abs x) (abs y) (abs $ x-y)
                renderPrimitive Lines $ do
                    vertex $ Vertex3 0.65 (0.65 :: GLfloat) 0.0
                    vertex $ Vertex3 x y 0.0
            -}

            color $ Color3 0 1 (1 :: GLdouble)
            text (0.65, 0.95) (map show [(1 :: Int)..10])
            
            color $ Color3 0 0 (0 :: GLdouble)
            preservingMatrix $ do
                translate $ Vector3 (0.25 :: GLdouble) 0.75 0.0
                textTTF font "Ubuntu!"

            -- Rectangle
            color $ Color3 1 0 (0 :: GLdouble)
            renderPrimitive LineLoop $ do
                let f (x,y) = vertex $ Vertex3 x (y :: GLfloat) 0.0
                mapM_ f [
                    (0.00, 0.00)
                  , (1.30, 0.00)
                  , (1.30, 1.00)
                  , (0.00, 1.00)]

        -- KEY
      , keyHandler   = Just $ KeyHandler $ \key state _ -> 
            when (state == Down) $
            case key of
                Char 'c'   -> writeIORef list []
                Char '\27' -> leaveMainLoop
                _        -> return ()

        -- MOUSE (CLICKING)
      , mouseHandler = Just $ MouseHandler $ \button pos ->
            case button of
                LeftButton ->
                    print (getPosition pos)
                _          -> return ()

        -- MOUSE (DRAGGING)
      , motionHandler = Just $ MotionHandler $ \pos ->
            print (getPosition pos)

      , title        = "Colors"
      , size         = Size 640 480
      , fps          = 30
    }
    windowLoop wc


randomPoint :: (Float, Float) -> IO (GLfloat, GLfloat)
randomPoint (l, r) = do
    x1 <- unsafeCoerce `liftM` randomRIO (l, r)
    x2 <- unsafeCoerce `liftM` randomRIO (l, r)
    return (x1, x2)


