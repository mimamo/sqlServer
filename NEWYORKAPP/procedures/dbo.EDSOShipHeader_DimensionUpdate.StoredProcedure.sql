USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_DimensionUpdate]    Script Date: 12/21/2015 16:01:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOShipHeader_DimensionUpdate] @CpnyId varchar(10), @ShipperId varchar(15), @Weight float, @WeightUOM varchar(6), @Volume float, @VolumeUOM varchar(6), @Length float, @LengthUOM varchar(6), @Height float, @HeightUOM varchar(6), @Width float, @WidthUOM varchar(6), @AltBOLNbr varchar(20) As
Update EDSOShipHeader Set Weight = @Weight, WeightUOM = @WeightUOM, Volume = @Volume,
  VolumeUOM = @VolumeUOM, Len = @Length, LenUOM = @LengthUOM, Height = @Height,
  HeightUOM = @HeightUOM, Width = @Width, WidthUOM = @WidthUOM, S4Future01 = @AltBOLNbr
  Where CpnyId = @CpnyId And ShipperId = @ShipperId
GO
