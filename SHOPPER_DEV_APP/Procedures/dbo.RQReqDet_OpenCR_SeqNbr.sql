USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQReqDet_OpenCR_SeqNbr]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQReqDet_OpenCR_SeqNbr    Script Date: 9/4/2003 6:21:39 PM ******/

/****** Object:  Stored Procedure dbo.RQReqDet_OpenCR_SeqNbr    Script Date: 7/5/2002 2:44:44 PM ******/

/****** Object:  Stored Procedure dbo.RQReqDet_OpenCR_SeqNbr    Script Date: 1/7/2002 12:23:14 PM ******/

/****** Object:  Stored Procedure dbo.RQReqDet_OpenCR_SeqNbr    Script Date: 1/2/01 9:39:39 AM ******/

/****** Object:  Stored Procedure dbo.RQReqDet_OpenCR_SeqNbr    Script Date: 11/17/00 11:54:33 AM ******/
CREATE PROCEDURE [dbo].[RQReqDet_OpenCR_SeqNbr] @parm1 varchar(10), @parm2 varchar(2)  AS

Select * from RQReqDet
where
ReqNbr = @parm1 and
ReqCntr < @parm2
Order by SeqNbr Desc, ReqCntr Desc
GO
