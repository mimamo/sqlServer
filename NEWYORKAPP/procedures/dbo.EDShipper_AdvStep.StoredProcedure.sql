USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipper_AdvStep]    Script Date: 12/21/2015 16:01:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShipper_AdvStep] @NextFunctionId varchar(8), @NextFunctionClass varchar(4), @CpnyId varchar(10), @ShipperId varchar(15)  As
Update SoShipHeader Set NextFunctionId = @NextFunctionID, NextFunctionClass = @NextFunctionClass
  Where CpnyId = @CpnyId And ShipperId = @ShipperId
GO
