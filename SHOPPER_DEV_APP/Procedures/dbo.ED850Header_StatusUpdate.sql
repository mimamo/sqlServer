USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_StatusUpdate]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850Header_StatusUpdate] @CpnyId varchar(10), @EDIPOID varchar(10), @CustId varchar(10),@UpdateStatus varchar(2), @SolShipToNbr varchar(10), @NbrLines smallint As
Update ED850Header Set CustId = @CustId, UpdateStatus = @UpdateStatus, SolShipToNbr = @SolShipToNbr, NbrLines = @NbrLines
Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
GO
