USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_EmpId_TSht_Rlsed_Paid_bySeq]    Script Date: 12/21/2015 16:13:22 ******/
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
