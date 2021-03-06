USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_20202GetNSFDocs2]    Script Date: 12/21/2015 14:17:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pp_20202GetNSFDocs2]
        @CpnyID char(10),
        @acct char(10),
        @sub char(24),
        @pernbr char(6),
        @begdate smalldatetime,
        @enddate smalldatetime

AS
  SELECT * FROM ARDoc d
   WHERE  d.cpnyid = @cpnyid and
          d.doctype in ('NS','RP') and
          d.rlsed = 1 and
          d.PerEnt = @pernbr and
          d.docdate between @begdate and @enddate and
          d.refnbr in (
             SELECT DISTINCT refnbr  FROM artran t
             WHERE t.acct = @acct and
                   t.sub = @sub and
                   t.cpnyid = @cpnyid and
                   t.PerEnt = @pernbr and
                   t.trantype in ('NS','RP') and
                   t.trandate between @begdate and @enddate)
GO
