USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqItemNbr_PV]    Script Date: 12/21/2015 14:06:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReqItemNbr_PV    Script Date: 12/17/97 10:48:45 AM ******/
CREATE PROCEDURE [dbo].[POReqItemNbr_PV] @parm1 Varchar(10), @Parm2 Varchar(2), @Parm3 Varchar(4) AS
SELECT * FROM POReqDet
WHERE ReqNbr = @parm1
 AND ReqCntr = @Parm2
 And SeqNbr Like @Parm3
 And SeqNbr <> ''
ORDER BY Reqnbr DESC, ReqCntr DESC
GO
