USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XAPCheck_Delete]    Script Date: 12/21/2015 15:43:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XAPCheck_Delete] @BatNbr char(10) AS
Delete from XAPCheck where BatNbr = @BatNbr
GO
