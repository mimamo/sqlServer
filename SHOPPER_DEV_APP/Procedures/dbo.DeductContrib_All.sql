USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeductContrib_All]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[DeductContrib_All] @parm1 varchar (10), @parm2 varchar ( 4), @parm3 varchar (10) as
       Select DeductContrib.*, Deduction.Descr
			from DeductContrib
				left outer join Deduction
					on DeductContrib.ContribId = Deduction.DedId
            where DeductContrib.DedId     like @parm1
                 and DeductContrib.ContribId like @parm3
                 and Deduction.CalYr            = @parm2
            Order by DeductContrib.DedId, DeductContrib.ContribId
GO
