USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Header_UpdateStatus]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810Header_UpdateStatus] @UpdateStatus varchar(2) As
Select CpnyId, EDIInvId From ED810Header Where UpdateStatus = @UpdateStatus
GO
