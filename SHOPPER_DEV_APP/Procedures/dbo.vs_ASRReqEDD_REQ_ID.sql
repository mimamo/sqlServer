USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[vs_ASRReqEDD_REQ_ID]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[vs_ASRReqEDD_REQ_ID] @parm1 int
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
AS
	select vs_asrreqedd.*,  vs_asrdistlist.*, cast (vs_appsrvrequest.status as char(1)),
	substring(vs_appsrvrequest.ReqTStamp, 1, 8),
	cast (vs_appsrvrequest.priority as char(1)),
	vs_appsrvrequest.scheduleoptions
	from vs_asrreqedd, vs_appsrvrequest,vs_asrdistlist
	where vs_asrreqedd.id = vs_appsrvrequest.id and vs_asrreqedd.id = vs_asrdistlist.requestid and
	vs_asrreqedd.ID = @parm1
        and vs_appsrvrequest.id NOT IN (select Mstrid from vs_appsrvrequest where MstrID <> 0)
	ORDER BY vs_asrreqedd.ID
GO
