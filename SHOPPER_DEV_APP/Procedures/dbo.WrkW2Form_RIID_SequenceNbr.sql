USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkW2Form_RIID_SequenceNbr]    Script Date: 12/16/2015 15:55:37 ******/
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
