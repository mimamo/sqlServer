USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQIRMultiDeptUserAcc_CF]    Script Date: 12/21/2015 13:35:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RQIRMultiDeptUserAcc_CF] @UserID varchar(47), @IRNbr varchar(10)  AS

SELECT RQItemReqHdr.*, Vendor.Name FROM RQItemReqHdr LEFT OUTER JOIN vendor ON RQItemReqHdr.Vendid = Vendor.vendid
WHERE
RequstnrDept in (Select Deptid from RQDeptAssign where Userid like @UserID) and
ItemReqNbr Like @IRNbr
ORDER BY itemReqNbr DESC
GO
