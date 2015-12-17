USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDAcknowledgement_Purge]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDAcknowledgement_Purge] @SolomonDateFrom smalldatetime, @SolomonDateTo smalldatetime As
Delete From EDAcknowledgement Where AckStatus = 1 And SolomonDate >= @SolomonDateFrom And
SolomonDate <= @SolomonDateTo
GO
