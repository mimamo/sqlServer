USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[vs_ASRReqEDD_PO]    Script Date: 12/21/2015 15:49:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[vs_ASRReqEDD_PO] @parm1 varchar(10), @parm2 varchar(15), @parm3 varchar(16)
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
AS
	select vs_asrreqedd.*,  vs_asrdistlist.*, cast (vs_appsrvrequest.status as char(1)),
	substring(vs_appsrvrequest.ReqTStamp, 1, 8)
	from vs_asrreqedd, vs_appsrvrequest,vs_asrdistlist
	where vs_asrreqedd.id = vs_appsrvrequest.id and vs_asrreqedd.id = vs_asrdistlist.requestid
	and doctype = 'U1'
	and PONbr Like @parm1 and VendID like @parm2 and APProject like @parm3
GO
