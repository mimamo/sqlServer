USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOHeader_BOLInfo]    Script Date: 12/21/2015 14:34:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOHeader_BOLInfo] @CpnyId varchar(10), @ShipperId varchar(15) As
Select CrossDock, Pro From EDSOHeader A, SOShipHeader B Where A.CpnyId = B.CpnyId And A.OrdNbr = B.OrdNbr And B.ShipperId = @ShipperId
GO
