USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[BPv_APHistCpny]    Script Date: 12/21/2015 14:05:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[BPv_APHistCpny] as

SELECT DISTINCT CpnyID, VendId
  FROM APHist
GO
