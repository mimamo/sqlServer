USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[BPv_AcctHist]    Script Date: 12/21/2015 13:35:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[BPv_AcctHist] as

SELECT DISTINCT CpnyID, Acct, Sub, FiscYr
  FROM AcctHist
GO
