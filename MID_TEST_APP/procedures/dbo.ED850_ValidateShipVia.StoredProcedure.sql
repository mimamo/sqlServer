USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850_ValidateShipVia]    Script Date: 12/21/2015 15:49:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850_ValidateShipVia] @CpnyId varchar(10), @EDIPOID varchar(10), @CustId varchar(15), @ShipToId varchar(10) As
Select ShipToId From SOAddress Where CustId = @CustId And ShipToId = @ShipToId And
  LTrim(RTrim(ShipViaId)) = '' Union
Select B.ShipToId From ED850SDQ A, SOAddress B Where B.CustId = @CustId And
  A.SolShipToId = B.ShipToId And LTrim(RTrim(B.ShipViaId)) = '' And A.CpnyId = @CpnyId And
  A.EDIPOID = @EDIPOID Union
Select B.ShipToId From ED850MarkFor A, SOAddress B Where B.CustId = @CustId And
  A.ShipToId = B.ShipToId And LTrim(RTrim(B.ShipViaId)) = '' And A.CpnyId = @CpnyId And
  A.EDIPOID = @EDIPOID
GO
