USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APCheckSel_Calc_Payment]    Script Date: 12/21/2015 13:35:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[APCheckSel_Calc_Payment] @accessnbr smallint, @paydate smalldatetime, @CuryInfoId char(4),
				 @CuryInfoMultDiv char(1),  @CuryInfoRate float, @CuryDecPl int, @CuryInfoEffDate smalldatetime, @RateType char(6), @Preview smallint, @APResult Int OUTPUT
AS
set nocount on

DECLARE	@MultDiv varchar(1)
DECLARE	@Rate Float
DECLARE 	@FromCuryID varchar(4)
DECLARE 	@CuryID varchar(4)
DECLARE 	@RefNbr varchar(10)
DECLARE 	@HoldRefNbr varchar(10)
DECLARE    	@BaseCuryID CHAR(10)
DECLARE		@BaseDecPl INT

SELECT @BaseCuryId = g.BaseCuryId
  from Glsetup g (nolock)

SELECT @BaseDecPl = c.DecPl
  FROM Currncy c (nolock)
  WHERE c.CuryId = @BaseCuryId

SELECT @CuryDecPl = c.DecPl
  FROM Currncy c (nolock)
  WHERE c.CuryId = @CuryInfoId

/*
**  Calculate payments
**
**  Clear discounts for late payments
*/
UPDATE	WrkCheckSel
SET	CuryDiscBal = 0
WHERE	AccessNbr = @accessnbr
AND	DiscDate < @paydate

/*
**  Calculate payment amounts
*/
UPDATE	WrkCheckSel
SET	CuryDiscTkn = CuryDiscBal,
	CuryPmtAmt = round( convert(dec(28,3),CuryDocBal) - convert(dec(28,3),CuryDiscBal), @CuryDecPl ),
	CuryRateType = CASE when CuryRateType = '' then @RateType else CuryRateType end
WHERE	AccessNbr = @accessnbr

/*** handle selecting docs to be paid that are a different currency -
	convert them to curreny check batch currency using the latest rate ***/

UPDATE Wrkchecksel
  SET
   CuryPmtAmt = Round(( (Convert(dec(28,3),CuryDocBal) -
    Convert(dec(28,3),CuryDiscBal))
    * ---MULTIPLY
   (CASE WHEN @CuryInfoMultDiv = 'M' THEN
      CASE WHEN @CuryInfoRate  <> 0
        THEN 1/Convert(dec(16,9),@CuryInfoRate)
      ELSE
        1
      END
    ELSE
     @CuryInfoRate
    END)
    ), @CuryDecPl ),
   CuryDiscTkn = Round(( Convert(dec(28,3),CuryDiscBal)
    * ---MULTIPLY
   (CASE WHEN @CuryInfoMultDiv = 'M' THEN
      CASE WHEN @CuryInfoRate  <> 0
        THEN 1/Convert(dec(16,9),@CuryInfoRate)
      ELSE
        1
      END

    ELSE
     @CuryInfoRate
    END)
    ) , @CuryDecPl )

  from wrkchecksel
        where  wrkchecksel.curyid = @BaseCuryID
        and wrkchecksel.accessnbr = @accessnbr
        and wrkchecksel.curyid <> @CuryInfoId

UPDATE Wrkchecksel
  SET CuryMultDiv = curyrate.multdiv, CuryRate = curyrate.rate,

   CuryPmtAmt = Round(( (Convert(dec(28,3),CuryDocBal) -
    Convert(dec(28,3),CuryDiscBal)) /
    ((CASE WHEN curyrate.multdiv = 'M' THEN
      CASE WHEN curyrate.rate  <> 0 AND wrkchecksel.curyid <> @BaseCuryID
        THEN 1/Convert(dec(16,9),curyrate.rate)
      ELSE
        1
      END
    ELSE
     CASE WHEN wrkchecksel.curyid = @BaseCuryID THEN
	1
     ELSE
	curyrate.rate
     END
    END)
    / ---divided by
   (CASE WHEN @CuryInfoMultDiv = 'M' THEN
      CASE WHEN @CuryInfoRate  <> 0
        THEN 1/Convert(dec(16,9),@CuryInfoRate)
      ELSE
        1
      END
    ELSE
     @CuryInfoRate
    END)
    )), @CuryDecPl ),
   CuryDiscTkn = Round(( Convert(dec(28,3),CuryDiscBal) /
   ((CASE WHEN curyrate.multdiv = 'M' THEN
      CASE WHEN curyrate.rate   <> 0 AND wrkchecksel.curyid <> @BaseCuryID
        THEN 1/Convert(dec(16,9),curyrate.rate)
      ELSE
        1
      END
    ELSE
     WrkCheckSel.CuryRate
    END)
    / ---divided by
   (CASE WHEN @CuryInfoMultDiv = 'M' THEN
      CASE WHEN @CuryInfoRate  <> 0
        THEN 1/Convert(dec(16,9),@CuryInfoRate)
      ELSE
        1
      END

    ELSE
     @CuryInfoRate
    END)
    )) , @CuryDecPl )

  from CuryRate, wrkchecksel
        where FromCuryId = wrkchecksel.curyid
          and ToCuryId = @BaseCuryID
        and ratetype = wrkchecksel.curyratetype
             and EffDate = (select max(EffDate) from CuryRate Cury2 where
               Cury2.FromCuryId = wrkchecksel.curyid
               and Cury2.ToCuryId = @BaseCuryID
          and Cury2.ratetype = wrkchecksel.curyratetype
          and Cury2.EffDate <=  @CuryInfoEffDate)
        and wrkchecksel.accessnbr = @accessnbr
        and wrkchecksel.curyid <> @CuryInfoId
GO
