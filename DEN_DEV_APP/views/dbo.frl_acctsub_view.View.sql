USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[frl_acctsub_view]    Script Date: 12/21/2015 14:05:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[frl_acctsub_view]
  (cpnyid, acct, sub, active, descr)
AS
  SELECT cpnyid, acct, sub, active, descr
    FROM vs_AcctSub (nolock)
GO
