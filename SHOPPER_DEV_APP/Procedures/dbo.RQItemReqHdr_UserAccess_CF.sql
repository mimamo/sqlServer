USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQItemReqHdr_UserAccess_CF]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RQItemReqHdr_UserAccess_CF] @parm1 Varchar(10), @Parm2 Varchar(47), @Parm3 Varchar(10) AS
SELECT RQItemReqHdr.*, Vendor.Name FROM RQItemReqHdr LEFT OUTER JOIN vendor ON RQItemReqHdr.Vendid = Vendor.vendid
WHERE RequstnrDept Like @Parm1 and
Requstnr Like @Parm2 and
ItemReqNbr Like @parm3
ORDER BY ItemReqNbr DESC
GO
