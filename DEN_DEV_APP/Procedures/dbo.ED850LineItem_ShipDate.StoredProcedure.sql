USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LineItem_ShipDate]    Script Date: 12/21/2015 14:06:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850LineItem_ShipDate] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select LineId From ED850LineItem Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And
ShipNBDate > ShipNLDate And ShipNLDate <> '01-01-1900'
GO
