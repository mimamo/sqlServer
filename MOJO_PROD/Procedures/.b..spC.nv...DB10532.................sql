USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10532]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10532]

AS


Update tTime Set Verified = 1


Update tPayment Set UnappliedPaymentAccountKey = NULL Where UnappliedPaymentAccountKey = 0
GO
