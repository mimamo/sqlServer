USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[POItemReqHdr_UserAccess]    Script Date: 12/21/2015 16:07:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POItemReqHdr_UserAccess    Script Date: 12/17/97 10:49:09 AM ******/
CREATE PROCEDURE [dbo].[POItemReqHdr_UserAccess] @parm1 Varchar(10), @Parm2 Varchar(47), @Parm3 Varchar(10) AS
SELECT * FROM POItemReqHdr
WHERE RequstnrDept Like @Parm1 AND
Requstnr Like @Parm2 AND
ItemReqNbr Like @parm3
ORDER BY ItemReqNbr DESC
GO
