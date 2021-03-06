USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[vp_03400_aptran_rcptnbr]    Script Date: 12/21/2015 15:55:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_03400_aptran_rcptnbr] as
select distinct w.useraddress ,rcptnbr, d.invcnbr as ExtRefNbr
  from  Wrkrelease w INNER LOOP Join 
             aptran a
             on w.batnbr = a.batnbr
		and w.module = "AP"
	INNER LOOP JOIN APDoc d ON d.BatNbr = a.BatNbr AND d.RefNbr = a.RefNbr
GO
