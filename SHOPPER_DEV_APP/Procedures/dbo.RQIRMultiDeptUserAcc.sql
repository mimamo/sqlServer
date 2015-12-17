USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQIRMultiDeptUserAcc]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQIRMultiDeptUserAcc    Script Date: 9/4/2003 6:21:20 PM ******/

/****** Object:  Stored Procedure dbo.RQIRMultiDeptUserAcc    Script Date: 7/5/2002 2:44:40 PM ******/
CREATE PROCEDURE [dbo].[RQIRMultiDeptUserAcc] @UserID varchar(47), @IRNbr varchar(10)  AS
SELECT  * FROM RQItemReqHdr
WHERE
RequstnrDept in (Select Deptid from RQDeptAssign where Userid like @UserID) and
ItemReqNbr Like @IRNbr
ORDER BY itemReqNbr DESC
GO
