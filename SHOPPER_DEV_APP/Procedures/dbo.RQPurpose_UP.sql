USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQPurpose_UP]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQPurpose_UP    Script Date: 9/4/2003 6:21:39 PM ******/

/****** Object:  Stored Procedure dbo.RQPurpose_UP    Script Date: 7/5/2002 2:44:43 PM ******/

/****** Object:  Stored Procedure dbo.RQPurpose_UP    Script Date: 1/7/2002 12:23:14 PM ******/

/****** Object:  Stored Procedure dbo.RQPurpose_UP    Script Date: 1/2/01 9:39:39 AM ******/
CREATE PROCEDURE  [dbo].[RQPurpose_UP] @parm1 as varchar(10), @parm2 as varchar(1), @parm3 as integer, @parm4 as varchar(8000) as
DECLARE @ptrval binary(16)
SELECT @ptrval = TEXTPTR(zzText)
FROM RQPurpose where PurposeNbr = @parm1 and PurposeType = @parm2
UPDATETEXT RQPurpose.zzText @ptrval @parm3 NULL  @parm4
GO
