USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDAcknowledgement_Purge]    Script Date: 12/21/2015 13:44:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDAcknowledgement_Purge] @SolomonDateFrom smalldatetime, @SolomonDateTo smalldatetime As
Delete From EDAcknowledgement Where AckStatus = 1 And SolomonDate >= @SolomonDateFrom And
SolomonDate <= @SolomonDateTo
GO
