USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHdr_UserAccess]    Script Date: 12/21/2015 14:34:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReqHdr_UserAccess    Script Date: 12/17/97 10:49:09 AM ******/
CREATE PROCEDURE [dbo].[POReqHdr_UserAccess] @parm1 Varchar(10), @Parm2 Varchar(47), @Parm3 Varchar(10), @Parm4 Varchar(10) AS
SELECT * FROM POReqHdr
WHERE RequstnrDept Like @Parm1 AND
Requstnr Like @Parm2 AND
CpnyID = @Parm3 AND
ReqNbr Like @parm4 AND
ReqCntr = '0'
ORDER BY ReqNbr DESC, ReqCntr DESC
GO
