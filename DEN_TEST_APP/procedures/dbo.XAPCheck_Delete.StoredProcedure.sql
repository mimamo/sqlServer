USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XAPCheck_Delete]    Script Date: 12/21/2015 15:37:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XAPCheck_Delete] @BatNbr char(10) AS
Delete from XAPCheck where BatNbr = @BatNbr
GO
