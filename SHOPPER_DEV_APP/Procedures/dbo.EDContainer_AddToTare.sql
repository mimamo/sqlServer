USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_AddToTare]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDContainer_AddToTare] @CpnyId varchar(10), @ShipperId varchar(15), @TareId varchar(10) As
Update EDContainer Set TareId = @TareId Where CpnyId = @CpnyId And ShipperId = @ShipperId And
TareFlag = 0 And LTrim(TareId) = ''
GO
