USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[vs_ASRReqEDD_REQ_GroupID]    Script Date: 12/21/2015 16:07:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[vs_ASRReqEDD_REQ_GroupID] @parm1 varchar(2), @parm2 int
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
AS
	select vs_asrreqedd.*,  vs_asrdistlist.*, cast (vs_appsrvrequest.status as char(1)),
	substring(vs_appsrvrequest.ReqTStamp, 1, 8),
	cast (vs_appsrvrequest.priority as char(1)),
	vs_appsrvrequest.scheduleoptions
	from vs_asrreqedd, vs_appsrvrequest,vs_asrdistlist
	where vs_asrreqedd.id = vs_appsrvrequest.id and vs_asrreqedd.id = vs_asrdistlist.requestid and
	vs_asrreqedd.DocType = @parm1 and vs_asrreqedd.EDDGroup = @parm2
        and vs_appsrvrequest.id NOT IN (select Mstrid from vs_appsrvrequest where MstrID <> 0)
	ORDER BY vs_asrreqedd.DocType, vs_asrreqedd.EDDGroup
GO
