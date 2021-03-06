USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APGetWrkPageCount]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/********* Object:  Stored Procedure dbo.APGetWrkPageCount   Script Date:  10/20/98 4:27pm *****/
CREATE PROCEDURE [dbo].[APGetWrkPageCount]
@parm1 varchar(15), @parm2 varchar(1), @parm3 varchar(10)
-- parm1 is vendid, parm2 is the option
AS
IF (@parm2 = 'A') -- All documents
        SELECT COUNT(*) FROM APDoc
        WHERE VendId = @parm1 AND CpnyID LIKE @parm3 AND DocClass = 'N' AND Rlsed = 1
IF (@parm2 = 'O') -- Open documents
        SELECT COUNT(*) FROM APDoc
        WHERE VendId = @parm1 AND CpnyID LIKE @parm3 AND DocClass = 'N' AND Rlsed = 1 AND OpenDoc = 1
IF (@parm2 = 'C') -- Current and open documents
        SELECT COUNT(*) FROM APDoc
        WHERE VendId = @parm1 AND CpnyID LIKE @parm3 AND DocClass = 'N' AND Rlsed = 1 AND (OpenDoc = 1 OR CurrentNbr = 1)
GO
