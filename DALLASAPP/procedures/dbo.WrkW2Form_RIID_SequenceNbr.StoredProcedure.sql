USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[WrkW2Form_RIID_SequenceNbr]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[WrkW2Form_RIID_SequenceNbr] @parm1 smallint, @parm2 smallint, @parm3 smallint as
       Select * from WrkW2Form
           where RI_ID        =       @parm1
             and SequenceNbr  BETWEEN @parm2 and @parm3
           order by RI_ID,
                    SequenceNbr
GO
