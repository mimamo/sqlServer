USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_ByUpdateStatus]    Script Date: 12/21/2015 14:17:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Header_ByUpdateStatus] @UpdateStatus varchar(2) As
Select * From ED850Header Where UpdateStatus = @UpdateStatus
GO
