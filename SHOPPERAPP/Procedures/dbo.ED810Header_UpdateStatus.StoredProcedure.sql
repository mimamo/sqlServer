USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Header_UpdateStatus]    Script Date: 12/21/2015 16:13:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810Header_UpdateStatus] @UpdateStatus varchar(2) As
Select CpnyId, EDIInvId From ED810Header Where UpdateStatus = @UpdateStatus
GO
