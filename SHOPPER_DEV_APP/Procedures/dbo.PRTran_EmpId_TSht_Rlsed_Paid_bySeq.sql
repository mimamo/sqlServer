USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_EmpId_TSht_Rlsed_Paid_bySeq]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[PRTran_EmpId_TSht_Rlsed_Paid_bySeq]
@EmpID varchar ( 10),
@Tsht  smallint,
@Rlsed smallint,
@Paid  smallint
AS
       Select * from PRTran
           where EmpId       =  @EmpID
             and TimeShtFlg  =  @Tsht
             and Rlsed       =  @Rlsed
             and Paid        =  @Paid
           order by EmpId,
                    TimeShtFlg,
                    Rlsed,
                    Paid,
                    ChkSeq,
                    EarnDedId,
                    WrkLocId
GO
