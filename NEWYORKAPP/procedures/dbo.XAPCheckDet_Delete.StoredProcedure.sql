USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XAPCheckDet_Delete]    Script Date: 12/21/2015 16:01:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XAPCheckDet_Delete] @BatNbr char (10) AS
Delete from XAPCheckDet where BatNbr = @BatNbr
GO
