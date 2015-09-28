module DiffFolder.Options (save) where

import Prelude (return, Unit (), unit)
import Control.Monad.Eff (Eff ())

save :: Eff () Unit
save = return unit
