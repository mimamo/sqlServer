USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDMCB_Batches_Update_Rates]    Script Date: 12/21/2015 16:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDMCB_Batches_Update_Rates]
	@BatNbr		    varchar( 10 ),
    @EBFileNbr      varchar( 6 ),
    @FileType       varchar( 1 ),
	@NewStatus      varchar( 1 ),
	@CuryEffDate    smalldatetime,
    @CuryMultDiv    varchar( 1 ),
	@CuryRate       float,
	@CuryRateType   varchar( 6 ),
	@Upd_Prog       varchar( 8 ),
	@Upd_User       varchar( 10 )

AS

    declare @CuryDecPl  smallint 
	Declare	@CurrDate 	smalldatetime

	SELECT	@CurrDate = cast(convert(varchar(10), getdate(), 101) as smalldatetime)

	SELECT	@CuryDecPl = DecPl
	FROM	Currncy (nolock)
	WHERE	CuryID = (Select TOP 1 CuryID FROM Batch (nolock) 
            WHERE  BatNbr = @BatNbr
                   and Module = 'AP'
                    and EditScrnNbr = '03030')

    -- XDDBatch Update
    UPDATE XDDBatch
    SET    CuryEffDate = @CuryEffDate,
           CuryMultDiv = @CuryMultDiv,
           CuryRate = @CuryRate,
           CuryRateType = @CuryRateType             
    WHERE  EBFileNbr = @EBFileNbr
           and BatNbr = @BatNbr
           and FileType = @FileType

    -- Batch Update
    UPDATE Batch
    SET    Status = @NewStatus,
           CuryRate = @CuryRate,
           CrTot = Case When CuryMultDiv = 'M'
                        then Round(CuryCrTot * @CuryRate, @CuryDecPl)
                        else Round(CuryCrTot / @CuryRate, @CuryDecPl)
                        end,
           CtrlTot = Case When CuryMultDiv = 'M'
                        then Round(CuryCtrlTot * @CuryRate, @CuryDecPl)
                        else Round(CuryCtrlTot / @CuryRate, @CuryDecPl)
                        end,
           CuryRateType = @CuryRateType,             
           CuryEffDate = @CuryEffDate,
           LUpd_DateTime = @CurrDate,
           LUpd_User = @Upd_User,
           LUpd_Prog = @Upd_Prog
    WHERE  BatNbr = @BatNbr
           and Module = 'AP'
           and EditScrnNbr = '03030'     -- just to be safe

    -- APDoc Update
    UPDATE APDoc
    SET    CuryRate = @CuryRate,
           OrigDocAmt = Case When CuryMultDiv = 'M'
                        then Round(CuryOrigDocAmt * @CuryRate, @CuryDecPl)
                        else Round(CuryOrigDocAmt / @CuryRate, @CuryDecPl)
                        end,
           PmtAmt = Case When CuryMultDiv = 'M'
                        then Round(CuryOrigDocAmt * @CuryRate, @CuryDecPl)
                        else Round(CuryOrigDocAmt / @CuryRate, @CuryDecPl)
                        end,
           CuryRateType = @CuryRateType,             
           CuryEffDate = @CuryEffDate,
           LUpd_DateTime = @CurrDate,
           LUpd_User = @Upd_User,
           LUpd_Prog = @Upd_Prog
    WHERE  BatNbr = @BatNbr                      

    -- APTran Update - note that some Cury fields don't get updated... this is the way SL does it
    UPDATE APTran
           -- CuryRate = @CuryRate,
    SET    TranAmt = Case When CuryMultDiv = 'M'
                        then Round(UnitPrice * @CuryRate, @CuryDecPl)
                        else Round(UnitPrice / @CuryRate, @CuryDecPl)
                        end,
           -- CuryRateType = @CuryRateType,             
           -- CuryEffDate = @CuryEffDate,
           LUpd_DateTime = @CurrDate,
           LUpd_User = @Upd_User,
           LUpd_Prog = @Upd_Prog
    WHERE  BatNbr = @BatNbr
GO
