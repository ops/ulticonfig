;;;
;;; Register definitions for UltiMem
;;;
;;; September 2020 ops
;;;

ULTIMEM_BASE        := $9FF0
ULTIMEM_CONTROL     := ULTIMEM_BASE + $0 ; UltiMem configuration register
ULTIMEM_MEM_CONFIG1 := ULTIMEM_BASE + $1 ; 00|I/O3|I/O2|RAM123 config
ULTIMEM_MEM_CONFIG2 := ULTIMEM_BASE + $2 ; BLK5|BLK3|BLK2|BLK1 config
ULTIMEM_ID          := ULTIMEM_BASE + $3 ; ID register (read-only)
ULTIMEM_RAM_BANK    := ULTIMEM_BASE + $4 ; RAM123 address register (lo/hi)
ULTIMEM_IO_BANK     := ULTIMEM_BASE + $6 ; I/O2 and I/O3 address register (lo/hi)
ULTIMEM_BLK1_BANK   := ULTIMEM_BASE + $8 ; BLK1 address register (lo/hi)
ULTIMEM_BLK2_BANK   := ULTIMEM_BASE + $A ; BLK2 address register (lo/hi)
ULTIMEM_BLK3_BANK   := ULTIMEM_BASE + $C ; BLK3 address register (lo/hi)
ULTIMEM_BLK5_BANK   := ULTIMEM_BASE + $E ; BLK5 address register (lo/hi)

; CONTROL register masks
ULTIMEM_LED_MASK      = 1 << 0
ULTIMEM_SWITCH0_MASK  = 1 << 1
ULTIMEM_SWITCH1_MASK  = 1 << 2
ULTIMEM_RESET_MASK    = 1 << 6
ULTIMEM_REG_HIDE_MASK = 1 << 7

; Memory type
ULTIMEM_MEMORY_NONE   = %00
ULTIMEM_MEMORY_FLASH  = %01
ULTIMEM_MEMORY_RAM_RO = %10
ULTIMEM_MEMORY_RAM_RW = %11

; MEM_CONFIG1 values
ULTIMEM_RAM123_NONE   = ULTIMEM_MEMORY_NONE   << 0
ULTIMEM_RAM123_RAM_RO = ULTIMEM_MEMORY_RAM_RO << 0
ULTIMEM_RAM123_FLASH  = ULTIMEM_MEMORY_FLASH  << 0
ULTIMEM_RAM123_RAM_RW = ULTIMEM_MEMORY_RAM_RW << 0

ULTIMEM_IO2_NONE      = ULTIMEM_MEMORY_NONE   << 2
ULTIMEM_IO2_RAM_RO    = ULTIMEM_MEMORY_RAM_RO << 2
ULTIMEM_IO2_FLASH     = ULTIMEM_MEMORY_FLASH  << 2
ULTIMEM_IO2_RAM_RW    = ULTIMEM_MEMORY_RAM_RW << 2

ULTIMEM_IO3_NONE      = ULTIMEM_MEMORY_NONE   << 4
ULTIMEM_IO3_RAM_RO    = ULTIMEM_MEMORY_RAM_RO << 4
ULTIMEM_IO3_FLASH     = ULTIMEM_MEMORY_FLASH  << 4
ULTIMEM_IO3_RAM_RW    = ULTIMEM_MEMORY_RAM_RW << 4

; MEM_CONFIG2 values
ULTIMEM_BLK1_NONE     = ULTIMEM_MEMORY_NONE   << 0
ULTIMEM_BLK1_RAM_RO   = ULTIMEM_MEMORY_RAM_RO << 0
ULTIMEM_BLK1_FLASH    = ULTIMEM_MEMORY_FLASH  << 0
ULTIMEM_BLK1_RAM_RW   = ULTIMEM_MEMORY_RAM_RW << 0

ULTIMEM_BLK2_NONE     = ULTIMEM_MEMORY_NONE   << 2
ULTIMEM_BLK2_RAM_RO   = ULTIMEM_MEMORY_RAM_RO << 2
ULTIMEM_BLK2_FLASH    = ULTIMEM_MEMORY_FLASH  << 2
ULTIMEM_BLK2_RAM_RW   = ULTIMEM_MEMORY_RAM_RW << 2

ULTIMEM_BLK3_NONE     = ULTIMEM_MEMORY_NONE   << 4
ULTIMEM_BLK3_RAM_RO   = ULTIMEM_MEMORY_RAM_RO << 4
ULTIMEM_BLK3_FLASH    = ULTIMEM_MEMORY_FLASH  << 4
ULTIMEM_BLK3_RAM_RW   = ULTIMEM_MEMORY_RAM_RW << 4

ULTIMEM_BLK5_NONE     = ULTIMEM_MEMORY_NONE   << 6
ULTIMEM_BLK5_RAM_RO   = ULTIMEM_MEMORY_RAM_RO << 6
ULTIMEM_BLK5_FLASH    = ULTIMEM_MEMORY_FLASH  << 6
ULTIMEM_BLK5_RAM_RW   = ULTIMEM_MEMORY_RAM_RW << 6
