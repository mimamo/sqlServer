USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_AdvStep]    Script Date: 12/21/2015 15:36:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOShipHeader_AdvStep] @CpnyId varchar(10), @ShipperId varchar(15) As
Select CpnyId, ShipperId, SOTypeId, OrdNbr, SiteId, AdminHold, CreditHold,
  CreditChk, Status, CustId, NextFunctionId From SOShipHeader Where CpnyId = @CpnyId And
  ShipperId = @ShipperId
GO
